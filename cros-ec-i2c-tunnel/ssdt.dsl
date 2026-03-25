// SSDT for ChromeOS EC I2C Tunnel passthrough
// Adds GOOG0012 tunnel devices as children of the CREC (EC Command Device)
// so the host can access I2C buses behind the EC via cros-ec-i2c-tunnel.
//
// Adjust google,remote-bus values to match your EC's I2C bus layout.
// This example is for Framework Laptop sunflower:
//   Bus 1: PD Controller 0 (CCG6 @ 0x08)
//   Bus 2: PD Controller 1 (CCG6 @ 0x40)
//   Bus 5: Keyboard IO Expander (IT8801 @ 0x38)
DefinitionBlock ("", "SSDT", 2, "FWK", "ECITUN", 0x00000001)
{
    External (\_SB.CREC, DeviceObj)

    Scope (\_SB.CREC)
    {
        Device (TUN1)
        {
            Name (_HID, "GOOG0012")
            Name (_UID, One)
            Name (_DDN, "EC I2C Tunnel Bus 1 - PD0 CCG6")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Name (_DSD, Package (0x02)
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package (0x01)
                {
                    Package (0x02)
                    {
                        "google,remote-bus",
                        One
                    }
                }
            })
        }

        Device (TUN2)
        {
            Name (_HID, "GOOG0012")
            Name (_UID, 2)
            Name (_DDN, "EC I2C Tunnel Bus 2 - PD1 CCG6")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Name (_DSD, Package (0x02)
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package (0x01)
                {
                    Package (0x02)
                    {
                        "google,remote-bus",
                        2
                    }
                }
            })
        }

        Device (TUN5)
        {
            Name (_HID, "GOOG0012")
            Name (_UID, 5)
            Name (_DDN, "EC I2C Tunnel Bus 5 - IT8801")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Name (_DSD, Package (0x02)
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package (0x01)
                {
                    Package (0x02)
                    {
                        "google,remote-bus",
                        5
                    }
                }
            })
        }
    }
}
