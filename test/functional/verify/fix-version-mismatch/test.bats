#!/usr/bin/env bats

load "../../swupdlib"

targetfile=6c27df6efcd6fc401ff1bc67c970b83eef115f6473db4fb9d57e5de317eba96e

setup() {
  clean_test_dir

  create_manifest_tar 10 MoM
  sign_manifest_mom 10

  create_manifest_tar 20 MoM
  sign_manifest_mom 20
  create_manifest_tar 20 os-core
  create_fullfile_tar 20 $targetfile
}

teardown() {
  clean_tars 10
  clean_tars 10 files

  clean_tars 20
  clean_tars 20 files

  revert_chown_root "$DIR/web-dir/20/files/$targetfile"
}

@test "verify version mismatch enforcement" {
  run sudo sh -c "$SWUPD verify --fix -m 10 $SWUPD_OPTS"

  # 14 = EMANIFEST_LOAD
  [ $status -eq 14 ]
  check_lines "$output"
}

# vi: ft=sh ts=8 sw=2 sts=2 et tw=80
