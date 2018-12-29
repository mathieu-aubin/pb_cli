#!/usr/bin/env bash
set -e

_TMPDIR=$(mktemp -d);
_REPOURL="https://github.com/ptpb/pb_cli/archive";
_REPOFILE="master.tar.gz";

fetch_source () {
  echo -e "\033[1mFetching/extracting pb_cli archive...\033[0m";
  curl -#LO ${_REPOURL}/${_REPOFILE} && \
    tar -xvf ${_REPOFILE} -C ${_TMPDIR} --strip-components=1;
}

cleanup () {
  echo -ne "\033[1mCleaning up...\033[0m";
  [[ -d ${_TMPDIR} ]] && rm -rf ${_TMPDIR} && \
    echo -e "\033[1m DONE.\033[0m";
  unset _TMPFILE _REPOURL _REPOFILE;
}

order66 () {
  # Move into temp dir
  pushd ${_TMPDIR} &>/dev/null;

    # Fetch source archive
    fetch_source;
    
    # Install script
    install -Dm755 src/pb.sh /usr/local/bin/pb;

  # Move out of temp dir
  popd &>/dev/null;

  # Proceed to cleanup
  cleanup;
}

# Check that temp dir has been created before proceeding
[[ ! -z ${_TMPDIR} ]] && order66 || echo -e "\033[1mThere was an error creating temporary folder, aborting.\033[0m";
