import envoy
import filepath
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type BaseDirectory {
  BaseDirectory(
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

pub fn new() -> BaseDirectory {
  // Reads $HOME
  let home_directory: String =
    read_home()
    |> result.unwrap("")

  // Reads $XDG_CONFIG_DIRS
  let config_directories: List(String) =
    read_config_dirs()
    |> result.unwrap(["/etc/xdg"])

  // Reads $XDG_DATA_DIRS
  let data_directories: List(String) =
    read_data_dirs()
    |> result.unwrap(["/usr/local/share", "/usr/share"])

  let runtime_directory: Option(String) =
    read_runtime_dirs()
    |> result.unwrap(None)

  BaseDirectory(
    data_home: filepath.join(home_directory, ".local/share"),
    config_home: filepath.join(home_directory, ".config"),
    cache_home: filepath.join(home_directory, ".cache"),
    state_home: filepath.join(home_directory, ".local/state"),
    data_dirs: data_directories,
    config_dirs: config_directories,
    runtime_dir: runtime_directory,
  )
}

/// Reads $HOME
pub fn read_home() -> Result(String, Nil) {
  let value =
    envoy.get("HOME")
    |> result.unwrap("")

  Ok(value)
}

/// Reads $XDG_CONFIG_DIRS
pub fn read_config_dirs() -> Result(List(String), Nil) {
  let value =
    envoy.get("XDG_CONFIG_DIRS")
    |> result.unwrap("")

  Ok(
    value
    |> string.split(":"),
  )
}

/// Reads $XDG_CONFIG_DIRS
pub fn read_data_dirs() -> Result(List(String), Nil) {
  let value =
    envoy.get("XDG_DATA_DIRS")
    |> result.unwrap("")

  Ok(
    value
    |> string.split(":"),
  )
}

/// Reads $XDG_RUNTIME_DIR
pub fn read_runtime_dirs() -> Result(Option(String), Nil) {
  let value =
    envoy.get("XDG_RUNTIME_DIR")
    |> result.unwrap("")

  Ok(Some(value))
}
