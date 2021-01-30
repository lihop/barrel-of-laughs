# Barrel of Laughs
Submission for the [Game Dev Field Guide Monthly Game Jam #1](https://itch.io/jam/gdfg-monthly-game-jam-1).

![Screenshot of Game](https://user-images.githubusercontent.com/3696783/106357223-5bd57900-6337-11eb-814e-9cf0c83705c7.png)

## Development
### Dependencies
- [Git](https://git-scm.com/)
- [Godot 3.2.4 Mono](https://godotengine.org/)
- [Dotnet SDK](https://dotnet.microsoft.com/)
- [metastore](https://github.com/przemoc/metastore)
- [NuGet](https://www.nuget.org/)
- [Trenchbroom](https://kristianduske.com/trenchbroom/)

### Setup
1. Clone this repo:
```
git clone https://github.com/lihop/barrel-of-laughs
```

2. Setup githooks: 
```
git config core.hooksPath .githooks
```

3. Clone submodules:
```
git submodule update --init --recursive
```

4. Build Fluid-HTN:
```
cd thirdparty/fluid-hierarchical-task-network
nuget restore
dotnet msbuild /t:restore
dotnet msbuild /p:Configuration=Release
```

5. Open the project in the Godot editor.

## License
The Barrel of Laughs code is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

The Barrel of Laughs data files (textures, models, sounds, music, etc.) are released under a mixture of licenses including, but not limited to, the following:
- Creative Commons Attribution (CC-BY)
- Public Domain (CC-0)

See the 'licenses.txt' files throughout the various data subdirectories for the licenses of each file.
