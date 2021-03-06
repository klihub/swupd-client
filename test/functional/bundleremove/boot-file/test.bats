#!/usr/bin/env bats

load "../../swupdlib"

setup() {
  clean_test_dir
  mkdir -p "$DIR/target-dir/usr/share/clear/bundles/"
  touch "$DIR/target-dir/usr/share/clear/bundles/test-bundle"
  mkdir -p "$DIR/target-dir/usr/lib/kernel/"
  touch "$DIR/target-dir/usr/lib/kernel/testfile"
  create_manifest_tar 10 MoM
  sign_manifest_mom 10
  create_manifest_tar 10 os-core
  create_manifest_tar 10 test-bundle
}

teardown() {
  clean_tars 10
}

@test "bundle-remove remove bundle containing a boot file" {
  run sudo sh -c "$SWUPD bundle-remove $SWUPD_OPTS test-bundle"

  [ "$status" -eq 0 ]
  check_lines "$output"
  [ ! -f "$DIR/target-dir/usr/lib/kernel/testfile" ]
}

# vi: ft=sh ts=8 sw=2 sts=2 et tw=80
