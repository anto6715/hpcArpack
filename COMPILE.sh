#!/bin/bash

#+++ Bash settings
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
#---

#+++ Variables
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
hpc_system="${HPC_SYSTEM}"
hpc_system_dir="${script_dir}/hpc_system"
armakes_dir="${script_dir}/ARMAKES"
readonly script_dir
#---

main() {
    # Read conf files
    hpc_system_file="${hpc_system_dir}/${hpc_system}"
    armake_file="${armakes_dir}/ARmake.${hpc_system}"

    if [ ! -f "${hpc_system_file}" ]; then
        echo 1>&@ "HPC configuration not found: ${hpc_system_file}"
        exit 1
    fi

    if [ ! -f "${armake_file}" ]; then
        echo 1>&@ "Make configuration not found: ${hpc_system_file}"
        exit 1
    fi

    echo "Loading ${hpc_system_file}"
    . "${hpc_system_file}"

    echo "Make: ${armake_file}"
    ln -s "${armake_file}" "ARMAKES/ARmake.inc"

    # Compile
    export HOME="${script_dir}"
    make clean
    make all
}

main "${@}"
