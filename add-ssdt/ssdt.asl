// Last number is the version, increase this from a decompiled table to
// override it.
DefinitionBlock ("", "SSDT", 2, "FWK", "FRMWC004", 0x00000001)
{
    Scope (_SB)
    {
        Device (CREC)
        {
            Name (_HID, "FRMWC004")
            Name (_UID, 1)
            Name (_DDN, "EC Command Device")

            Method(_STA, 0)
            {
                Return (0xF)
            }
        }
    }
}
