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
  gleam_xdg.read_home()
  |> result.unwrap("")
  |> should.equal("/home/haruki")
}
