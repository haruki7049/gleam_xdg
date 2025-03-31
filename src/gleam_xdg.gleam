import envoy
import gleam/option.{type Option, None}
import gleam/result

pub type BaseDirectory {
  BaseDirectory(
    shared_prefix: String,
    user_prefix: String,
    data_home: String,
    config_home: String,
    cache_home: String,
    state_home: String,
    data_dirs: List(String),
    config_dirs: List(String),
    runtime_dir: Option(String),
  )
}

pub type Error {
  Error(kind: ErrorKind)
}

pub type ErrorKind {
  AnyError
}

/// Reads the process environment, determines the XDG base directories,
/// and returns a value that can be used for lookup.
/// The following environment variables are examined:
///
///   * `HOME`; if not set: use the same fallback as `std::env::home_dir()`;
///     if still not available: return an error.
///   * `XDG_DATA_HOME`; if not set: assumed to be `$HOME/.local/share`.
///   * `XDG_CONFIG_HOME`; if not set: assumed to be `$HOME/.config`.
///   * `XDG_CACHE_HOME`; if not set: assumed to be `$HOME/.cache`.
///   * `XDG_STATE_HOME`; if not set: assumed to be `$HOME/.local/state`.
///   * `XDG_DATA_DIRS`; if not set: assumed to be `/usr/local/share:/usr/share`.
///   * `XDG_CONFIG_DIRS`; if not set: assumed to be `/etc/xdg`.
///   * `XDG_RUNTIME_DIR`; if not accessible or permissions are not `0700`:
///     record as inaccessible (can be queried with
///     [has_runtime_directory](method.has_runtime_directory)).
///
/// As per specification, if an environment variable contains a relative path,
/// the behavior is the same as if it was not set.
pub fn new() -> BaseDirectory {
  let home: String = result.unwrap(read_home(), "")

  BaseDirectory(
    shared_prefix: "",
    user_prefix: "",
    data_home: "",
    config_home: "",
    cache_home: "",
    state_home: "",
    data_dirs: [],
    config_dirs: [],
    runtime_dir: None,
  )
}

/// Reads $HOME
pub fn read_home() -> Result(String, Nil) {
  let value =
    envoy.get("HOME")
    |> result.unwrap("")

  Ok(value)
}
