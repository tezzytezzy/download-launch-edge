#! /bin/bash

# All variables in bash are global by default
# Global variables should be in ALL_CAPITAL_CASE with readonly designation 
# Variable substitution within a string should be "${variable}", NOT just $variable
# REFERENCE: https://google.github.io/styleguide/shellguide.html
# Use https://www.shellcheck.net/ for linting

function get_script_directory() {
  #`declare` stipulates a variable as "local" by default. `-r` makes it readonly
  declare -r SCRIPT_PATH="${BASH_SOURCE:-$0}"
  # e.g. ./thisscript.sh   
  declare -r FULL_SCRIPT_PATH="$(realpath "${SCRIPT_PATH}")"
  # e.g. /home/to/thisscript.sh
  
  echo "$(dirname "${FULL_SCRIPT_PATH}")"
  # e.g. /home/to
}

function get_latest_edge_deb_filename() {
  #`declare` stipulates a variable as "local" by default. `-r` makes it readonly

  # Curl's optional parameters:
  #   Treats non-2xx/3xx responses as errors (-f).
  #   Disables the progress meter (-sS).
  #   Handles HTTP redirects (-L).
  declare -r HTML_TEXT="curl -fsSL ${EDGE_PACKAGE_URL}"

  # Redirect to standard error to be able to return the .deb file name at the bottom in this function 
  echo ">>Extracting the latest file's timestamp..." >&2
  
  # The last column shows file size e.g. 165.2 MB
  # The second last column does hh:mm e.g. 19:26 
  # The third last does date in dd-MMM-yyyy format e.g. 16-Nov-2023
  # We need only those second and third last columns by reversing twice
  # `tr -s ' '` removes repeated spaces with `-s (--squeeze)` by replacing each input sequence of a repeated character that is listed in SET1 with a single occurrence of that character
  #   If you look carefully there are 2 spaces between last and second last columns e.g. 20:26__165.1 MB
  # LC_ALL is the environment variable that overrides all the other localisation settings, adhering to the ASCII order
  # 1st sorting (1.8n): 1st field (dd-MMM-yyyy) by year, from the 8th char position (til the end - unspecified)
  # 2st sorting (1.4,1.6M): 1st field (dd-MMM-yyyy) by month, from the 4th char position to the 6th, using the `M` flag to recognise non-numeric MMM (that's why no `n`)
  # 3rd sorting (1.1,1.2n): 1st field (dd-MMM-yyyy) by day, from the 1st char position to the 2nd
  # 4th sorting (2.1,2.2n): 2nd field (hh:mm) by hour, from the 1st char position to the 2nd
  # 5th sorting (2.4n): 2nd field (hh:mm) by minute, from the 4th char position (til the end - unspecified)
  declare -r LATEST_TIMESTAMP=$(${HTML_TEXT} | rev | tr -s ' ' | cut -d " " -f3-4 | rev | LC_ALL=C sort -k 1.8n -k 1.4,1.6M -k 1.1,1.2n -k 2.1,2.2n -k 2.4n | tail -n 1)
  # e.g. 02-Nov-2023 20:25
  echo "${LATEST_TIMESTAMP}" >&2

  declare -r LAST_LINE_TEXT="$(${HTML_TEXT} | grep "${LATEST_TIMESTAMP}")"
  # e.g. <a href="microsoft-edge-stable_119.0.2151.44-1_amd64.deb">microsoft-edge-stable_119.0.2151.44-1_amd64.deb</a>                                                     02-Nov-2023 20:25

  # Using bash's built-in parameter substitution, only for removal of character(s)
  # Ref: https://tldp.org/LDP/abs/html/parameter-substitution.html
  # # and ## work from the left end (beginning) of string, while % and %% work from the right end
  # `#*\"` = Find the very first `"` (shortest possible match) from the beginning, escaped with `\`, and delete all the chracter(s), denoted by `*`, up to that occurence 
  declare -r FRONT_OFF_TEXT="${LAST_LINE_TEXT#*\"}"
  # e.g. microsoft-edge-stable_119.0.2151.44-1_amd64.deb">microsoft-edge-stable_119.0.2151.44-1_amd64.deb</a>                                                     02-Nov-2023 20:25

  # Redirect to standard error to be able to return the .deb file name at the bottom in this function - just before returning the file name
  echo ">>Extracting the latest Edge file name..." >&2

  # `%\"*` = Find the very first `"` (shortest possible match) from the end, escaped with `\`, and delete all the chracter(s), denoted by `*`, up to that occurence  
  echo "${FRONT_OFF_TEXT%\"*}"
  # e.g. microsoft-edge-stable_119.0.2151.44-1_amd64.deb
}

echo ">>Configuring the working directory..."
SCRIPT_DIRECTORY=$(get_script_directory)
readonly SCRIPT_DIRECTORY
echo "${SCRIPT_DIRECTORY}"

EDGE_PACKAGE_URL=https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable
readonly EDGE_PACKAGE_URL

EDGE_DEB_FILENAME=$(get_latest_edge_deb_filename)
readonly EDGE_DEB_FILENAME
echo "${EDGE_DEB_FILENAME}"

echo ">>Downloading the latest Edge .deb file..."
WGET_COMMAND_STRING="wget -P ${SCRIPT_DIRECTORY} -O ${EDGE_DEB_FILENAME} ${EDGE_PACKAGE_URL}/${EDGE_DEB_FILENAME}"
readonly WGET_COMMAND_STRING
echo "${WGET_COMMAND_STRING}"
(${WGET_COMMAND_STRING})

echo ">>Extracting the deb file..."
EDGE_DEB_FILE_FULL_PATH="${SCRIPT_DIRECTORY}"/"${EDGE_DEB_FILENAME}"
readonly EDGE_DEB_FILE_FULL_PATH
ARCHIVE_COMMAND_STRING="ar x ${EDGE_DEB_FILE_FULL_PATH}"
readonly ARCHIVE_COMMAND_STRING
echo "${ARCHIVE_COMMAND_STRING}"
(${ARCHIVE_COMMAND_STRING})

# Data.tar.xz is "a compressed file and it contains all the files to be installed on your system."
echo ">>Extracting the data.tar.xz file..."
EDGE_DATA_TAR_GZ_FILE=data.tar.xz
readonly EDGE_DATA_TAR_GZ_FILE
TAR_COMMAND_STRING_DATA="tar xfC ${SCRIPT_DIRECTORY}/${EDGE_DATA_TAR_GZ_FILE} ${SCRIPT_DIRECTORY}"
echo "${TAR_COMMAND_STRING_DATA}"
(${TAR_COMMAND_STRING_DATA})

# Control.tar.gz is "a compressed file and it contains md5sums and control directory for building package."
echo ">>Extracting the control.tar.xz file..."
EDGE_CONTROL_TAR_GZ_FILE=control.tar.xz
readonly EDGE_CONTROL_TAR_GZ_FILE
TAR_COMMAND_STRING_CONTROL="tar xfC ${SCRIPT_DIRECTORY}/${EDGE_CONTROL_TAR_GZ_FILE} ${SCRIPT_DIRECTORY}"
echo "${TAR_COMMAND_STRING_CONTROL}"
(${TAR_COMMAND_STRING_CONTROL})

# Without `--no-sandbox`, an error message "Running as root without --no-sandbox is not supported. See https://crbug.com/638180."
echo ">>Launching the Edge in un-sandboxed and private modes..."
EDGE_EXEC_COMMAND_STRING="${SCRIPT_DIRECTORY}/opt/microsoft/msedge/microsoft-edge --no-sandbox -inprivate"
echo "${EDGE_EXEC_COMMAND_STRING}"
(${EDGE_EXEC_COMMAND_STRING})

# TODO(tezzy): Use redirect or stdin from the curl command instead, so as not to call the Edge package site twice.
# I deliberately do not save its output as a file and read it off by `cat` like below
# grep -Ff <(cat package.html | rev | cut -d " " -f1-2 | rev | sort -k 1.8n -k 1.4,1.6M -k 1.1,1.2n -k 2.1,2.2n -k 2.4n | tail -n 1) package.html
