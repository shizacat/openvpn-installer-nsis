#
# OpenVPN Application and Configuration Installer
# @version $Id$
#

# Set Defaults
# Allows for /DOUTPUT_EXE=something.exe /DCLIENT_CFG=config\file.cfg

!ifndef CONFIG_DIR
    !define CONFIG_DIR "config"
!endif

!ifndef OUTPUT_EXE
    !define OUTPUT_EXE "vpn-install.exe"
!endif

BrandingText "OpenVPN Installer"
Caption "Automagic OpenVPN Installer"
CompletedText "Automagic OpenVPN Installation Complete"
# ComponentText "OpenVPN"
#Icon images\logo.ico
#InstallColors 336699 333333
#InstProgressFlags colored smooth
Name "OpenVPN Installer"
OutFile ${OUTPUT_EXE}
RequestExecutionLevel admin
ShowInstDetails show
XPStyle off
# TargetMinimalOS 5.1

Section ""

#    Var /GLOBAL targetdir

    # Maybe warn that directory is not here?
    # @todo check for OpenVPN Dir in Registry

    DetailPrint "Checking OpenVPN"
    IfFileExists "$PROGRAMFILES64\OpenVPN\bin\openvpn-gui.exe" goodVPN failVPN
    failVPN:
        MessageBox MB_OK "We must install OpenVPN First, please complete the following installer choosing Next or Continue as necessary"
        SetOutPath $EXEDIR
        DetailPrint "Extracting OpenVPN $OUTDIR"
        # Bundle OpenVPN Installer
        File source\openvpn-install-2.3.10-I603-x86_64.exe
        # ExecShell "open" "$EXEDIR\openvpn-install-2.3.10-I603-x86_64.exe"
        ExecWait "$EXEDIR\openvpn-install-2.3.10-I603-x86_64.exe" $0
        # Zero == Success, One == Fail, handle
        IntCmp $0 0 goodInstall
            DetailPrint "Failed to Install: $0"
            MessageBox MB_OK|MB_ICONSTOP "Failed to install OpenVPN, this is required to continue. Installation aborted."
            Quit
        goodInstall:
        Goto doneVPN
    goodVPN:
        DetailPrint "OpenVPN Already Installed"
    doneVPN:

    # @todo read registry for install values?
    # @todo find the registry entries for the OpenVPN configuration
    # ReadRegStr $0 HKLM Software\
    # SetOutPath $0
    SetOutPath "$PROGRAMFILES64\OpenVPN\config"

    # Full contents of Config
    File /r /x .svn ${CONFIG_DIR}

    # un-installer
    #WriteUninstaller "$EXEDIR\remove-full-openvpn.exe"

SectionEnd