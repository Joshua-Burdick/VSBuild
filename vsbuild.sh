# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <project_name>"
    exit 1
fi

# Get the arguments
SOURCE_DIR=$1
PROJECT_NAME=$2

# Create a GUID for the project
PROJECT_GUID=$(uuidgen | tr 'a-f' 'A-F')

# Create the directory structure
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Source Files"
mkdir -p "$PROJECT_NAME/x64/Debug"

# Copy the source files
cp "$SOURCE_DIR"/*.cpp "$PROJECT_NAME/$PROJECT_NAME/Source Files"
cp "$SOURCE_DIR"/*.h "$PROJECT_NAME/$PROJECT_NAME/Source Files"

# Create the .sln file
cat > "$PROJECT_NAME/$PROJECT_NAME.sln" <<EOL
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 16
VisualStudioVersion = 16.0.28701.123
MinimumVisualStudioVersion = 10.0.40219.1
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "$PROJECT_NAME", "$PROJECT_NAME\\$PROJECT_NAME.vcxproj", "{$PROJECT_GUID}"
EndProject
Global
    GlobalSection(SolutionConfigurationPlatforms) = preSolution
        Debug|x64 = Debug|x64
        Release|x64 = Release|x64
    EndGlobalSection
    GlobalSection(ProjectConfigurationPlatforms) = postSolution
        {$PROJECT_GUID}.Debug|x64.ActiveCfg = Debug|x64
        {$PROJECT_GUID}.Debug|x64.Build.0 = Debug|x64
        {$PROJECT_GUID}.Release|x64.ActiveCfg = Release|x64
        {$PROJECT_GUID}.Release|x64.Build.0 = Release|x64
    EndGlobalSection
EndGlobal
EOL

# Create the .vcxproj file
cat > "$PROJECT_NAME/$PROJECT_NAME/$PROJECT_NAME.vcxproj" <<EOL
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup Label="ProjectConfigurations">
    <ProjectConfiguration Include="Debug|x64">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|x64">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <PropertyGroup Label="Globals">
    <ProjectGuid>{$PROJECT_GUID}</ProjectGuid>
    <RootNamespace>$PROJECT_NAME</RootNamespace>
    <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion>
  </PropertyGroup>
  <Import Project="\$(VCTargetsPath)\\Microsoft.Cpp.Default.props" />
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <WholeProgramOptimization>true</WholeProgramOptimization>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <Import Project="\$(VCTargetsPath)\\Microsoft.Cpp.props" />
  <ImportGroup Label="ExtensionSettings">
  </ImportGroup>
  <ImportGroup Label="Shared">
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'">
    <Import Project="\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'">
    <Import Project="\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <PropertyGroup Label="UserMacros" />
  <PropertyGroup />
  <ItemGroup>
EOL

# Add source files to .vcxproj
for file in "$SOURCE_DIR"/*.cpp; do
    filename=$(basename -- "$file")
    echo "    <ClCompile Include=\"Source Files\\$filename\" />" >> "$PROJECT_NAME/$PROJECT_NAME/$PROJECT_NAME.vcxproj"
done

for file in "$SOURCE_DIR"/*.h; do
    filename=$(basename -- "$file")
    echo "    <ClInclude Include=\"Source Files\\$filename\" />" >> "$PROJECT_NAME/$PROJECT_NAME/$PROJECT_NAME.vcxproj"
done

cat >> "$PROJECT_NAME/$PROJECT_NAME/$PROJECT_NAME.vcxproj" <<EOL
  </ItemGroup>
  <Import Project="\$(VCTargetsPath)\\Microsoft.Cpp.targets" />
  <ImportGroup Label="ExtensionTargets">
  </ImportGroup>
</Project>
EOL

echo "Visual Studio project $PROJECT_NAME created successfully."
