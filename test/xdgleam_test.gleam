import envoy
import gleam/option.{None, Some}
import gleam/result
import gleeunit
import gleeunit/should
import xdgleam

pub fn main() {
  gleeunit.main()
}

/// The test for xdgleam/home function
pub fn home_test() {
  // Backup original HOME envvar
  let home_backup: String =
    envoy.get("HOME")
    |> result.unwrap("ERROR")

  envoy.set("HOME", "/home/haruki")

  xdgleam.home()
  |> result.unwrap("")
  |> should.equal("/home/haruki")

  // Cleanup process
  envoy.set("HOME", home_backup)
}

/// The test for xdgleam/config_dirs function
pub fn config_dirs_test() {
  // Backup original HOME envvar
  let config_dirs_backup: String =
    envoy.get("XDG_CONFIG_DIRS")
    |> result.unwrap("ERROR")

  envoy.set(
    "XDG_CONFIG_DIRS",
    "/etc/xdg:/home/haruki/.local/state/nix/profile/etc/xdg",
  )

  xdgleam.config_dirs()
  |> result.unwrap([])
  |> should.equal(["/etc/xdg", "/home/haruki/.local/state/nix/profile/etc/xdg"])

  // Cleanup process
  envoy.set("XDG_CONFIG_DIRS", config_dirs_backup)
}

/// The test for xdgleam/config_dirs function
pub fn data_dirs_test() {
  // Backup original HOME envvar
  let data_dirs_backup: String =
    envoy.get("XDG_DATA_DIRS")
    |> result.unwrap("ERROR")

  envoy.set("XDG_DATA_DIRS", "/usr/local/share:/usr/share")

  xdgleam.data_dirs()
  |> result.unwrap([])
  |> should.equal(["/usr/local/share", "/usr/share"])

  // Cleanup process
  envoy.set("XDG_CONFIG_DIRS", data_dirs_backup)
}

/// The test for xdgleam/home function
pub fn runtime_dirs_test() {
  // Backup original HOME envvar
  let runtime_dir_backup: String =
    envoy.get("XDG_RUNTIME_DIR")
    |> result.unwrap("ERROR")

  envoy.set("XDG_RUNTIME_DIR", "/run/user/1000")

  xdgleam.runtime_dirs()
  |> result.unwrap(None)
  |> should.equal(Some("/run/user/1000"))

  // Cleanup process
  envoy.set("XDG_RUNTIME_DIR", runtime_dir_backup)
}
