# VSBuild
A C++ Visual Studio Project Builder for Unix-based systems.

## Running the Script
Once you have downloaded the script, you can use it to convert simple C++ projects into Visual Studio projects.

Once you have navigated to the target directory where you want the final VS Project to be, run the following terminal command:

```$ path-to-vsbuild/vsbuild.sh path-to-project ProjectName```

where `path-to-vsbuild` is the path to the script's parent directory, `path-to-project` is the path of the project you want to convert, and `ProjectName` is what you want to name the outputted project.

Enjoy your new VS Project!

## Credits
- Jack Canducci for the implementation
- ChatGPT for deriving VS project structure and VS file data formats.
