# Go Devcontainer

A Go development container that help you keeping everything up to date.

![Demo](demo.gif)

## Usage

The easiest way to use this devcontainer is to use the [Go Template](https://github.com/adrienaury/go-template). The Go Template is pre-configured, it's very easy to setup.

### Prerequisites

You need :

- Visual Studio Code ([download](https://code.visualstudio.com/)) with the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed.
- Docker Desktop (Windows, macOS) or Docker CE/EE (Linux)

Details are available on [the official Visual Studio documentation](https://code.visualstudio.com/docs/remote/containers#_getting-started).

### Configure your workspace

Create a file `.devcontainer/devcontainer.json` in the root of your project.

```javascript
// For format details, see https://aka.ms/devcontainer.json.
{
  "name": "Go Devcontainer",

  // this will always use the latest release, but it's also possible to stick to a specific release
  "image": "adrienaury/go-devcontainer:latest",

  // Set *default* container specific settings.json values on container create.
  "settings": {
    "terminal.integrated.shell.linux": "/bin/zsh"
  },

  // Add the IDs of extensions you want installed when the container is created.
  "extensions": ["golang.go"],

  // Needed when using a ptrace-based debugger like C++, Go, and Rust
  "runArgs": [ "--init", "--cap-add=SYS_PTRACE", "--security-opt", "seccomp=unconfined" ],

  // Needed to use the Docker CLI from inside the container. See https://aka.ms/vscode-remote/samples/docker-from-docker.
  "mounts": [ "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind" ],

  // Needed to connect as a non-root user. See https://aka.ms/vscode-remote/containers/non-root.
  "remoteUser": "vscode"
}
```

Then use `F1` key or `Ctrl+Shift+P` and use the `Remote-Containers: Rebuild and Reopen in Container` option.

### Keep your workspace up to date

When starting a new terminal inside the container, a message will tell you if new versions are available. It will also print the command to use in order to update the tool.

```text
     ____         ____                            _        _                 
    / ___| ___   |  _ \  _____   _____ ___  _ __ | |_ __ _(_)_ __   ___ _ __ 
   | |  _ / _ \  | | | |/ _ \ \ / / __/ _ \| '_ \| __/ _` | | '_ \ / _ \ '__|
   | |_| | (_) | | |_| |  __/\ V / (_| (_) | | | | || (_| | | | | |  __/ |   
    \____|\___/  |____/ \___| \_/ \___\___/|_| |_|\__\__,_|_|_| |_|\___|_|   
                                                                             
Alpine Linux           v3.13.5 ✅
├── Docker Client     v20.10.6 ✅
├── Docker Compose     v1.29.1 ✅
├── Git Client         v2.30.2 ✅
├── Zsh                   v5.8 ✅
├── Go                 v1.16.3 ✅

Development tools
├── Gopls                0.6.9 🆕 run 'sudo instool gopls 0.6.10' to update to latest version
├── Delve                1.6.0 ✅
├── Gopkgs               2.1.2 ✅
├── Goplay               1.0.0 ✅
├── Gomodifytags        1.13.0 ✅
├── Gotests              1.6.0 ✅
├── GolangCI Lint       1.39.0 ✅
├── Venom           1.0.0-rc.4 ✅
├── Changie              0.4.1 ✅
├── Github CLI           1.9.2 ✅
├── Neon                 1.5.3 ✅
├── GoReleaser         0.164.0 ✅
├── SVU                  1.3.2 ✅
```

Just type the command in a terminal to update.

```console
sudo instool gopls 0.6.10
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
