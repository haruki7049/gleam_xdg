import envoy
import gleam/result
import gleam_xdg
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

/// The test for gleam_xdg/read_home function
pub fn read_home_test() {
  // Backup original HOME envvar
  let home_backup: String =
    envoy.get("HOME")
    |> result.unwrap("ERROR")

  envoy.set("HOME", "/home/haruki")

  gleam_xdg.read_home()
  |> result.unwrap("")
  |> should.equal("/home/haruki")

  // Cleanup process
  envoy.set("HOME", home_backup)
}
