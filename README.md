# Snggle
Private keys manager

## Usage
For detailed instructions on the installation process, please refer to the [USAGE.md](./USAGE.md) file.

## Installation
Use git clone to download [Snggle](https://github.com/snggle) project.
```bash
git clone git@github.com:snggle/snggle.git
```

The project runs on flutter version **3.16.2**. You can use [fvm](https://fvm.app/docs/getting_started/installation)
for easy switching between versions otherwise see [flutter installation](https://docs.flutter.dev/get-started/install)
```bash
# Install and use required flutter version
fvm install 3.16.2
fvm use 3.16.2

# Install required packages in pubspec.yaml
fvm flutter pub get

# Run project
fvm flutter run 
```

To generate config files use
```bash
fvm flutter pub run build_runner
```
```bash
# Built-in Commands 
# - build: Runs a single build and exits.
# - watch: Runs a persistent build server that watches the files system for edits and does rebuilds as necessary
# - serve: Same as watch, but runs a development server as well

# Command Line Options
# --delete-conflicting-outputs: Assume conflicting outputs in the users package are from previous builds, and skip the user prompt that would usually be provided.
# 
# Command example:

fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

## Tests
To run Unit Tests / Integration tests
```bash
# Run all Unit Tests
fvm flutter test test

# To run specific Unit Test
fvm flutter test path/to/test.dart
```

## Contributing
Pull requests are welcomed. For major changes, please open an issue first, to enable a discussion on what you would like to improve. Please make sure to provide and update tests as well. 