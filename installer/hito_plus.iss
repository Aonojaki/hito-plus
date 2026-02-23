#define MyAppName "Hito+"
#define MyAppPublisher "Hito+"

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

#ifndef SourceDir
  #define SourceDir "..\\build\\windows\\x64\\runner\\Release"
#endif

#ifndef OutputDir
  #define OutputDir "..\\dist"
#endif

[Setup]
AppId={{4A8B8A9C-8A5A-49E4-A2D0-8E220982C93E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\Hito+
DefaultGroupName=Hito+
DisableProgramGroupPage=yes
OutputBaseFilename=hito_plus_setup_{#MyAppVersion}
OutputDir={#OutputDir}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
Source: "{#SourceDir}\\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\Hito+"; Filename: "{app}\\hito_plus.exe"
Name: "{autodesktop}\\Hito+"; Filename: "{app}\\hito_plus.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\\hito_plus.exe"; Description: "Launch Hito+"; Flags: nowait postinstall skipifsilent
