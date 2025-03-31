import envoy
import gleam/result
import gleam_xdg
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

/// The test for gleam_xdg/read_home function
/// FIXME: Rewrite to use Mock
pub fn read_home_test() {
  let home_backup: String =
    envoy.get("HOME")
    |> result.unwrap("ERROR")

  envoy.set("HOME", "/home/haruki")

  gleam_xdg.read_home()
  |> result.unwrap("")
  |> should.equal("/home/haruki")

  envoy.set("HOME", home_backup)
}
