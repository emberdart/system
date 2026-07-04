{ lib, pkgs, isDesktop, domain, hostname, privateDir, ... }:
{
  security = {
    acme = {
      defaults = {
        email = "acme@${domain}";
        group = "nginx";
        # either dnsProvider, webroot, listenHTTP or s3Bucket.
        # webroot = "/var/lib/acme/acme-challenge";
        # dnsPropagationCheck = true;
      };
      acceptTerms = true;
      certs = {
        "${hostname}.${if isDesktop then "home." else ""}${domain}" = {
          dnsProvider = "digitalocean";
          credentialFiles = {
            DO_AUTH_TOKEN_FILE = "${privateDir}/digitalocean/auth_token";
          };
          extraDomainNames = [
            # these need to be real and pointing here, they can't be "just in case"
            # "nextcloud.${domain}"
            # "roqqett.${domain}"
            # "roqqett.home.${domain}"
            # "roq-wp.${domain}"
            "dev.${domain}"
            "dev.jolharg.com"
            "dev.blog.jolharg.com"
            "dev.madhackerreviews.com"
            "dev.m0ori.com"
            "dev.blog.m0ori.com"
            "dev.blog.${domain}"
            "dev.jobfinder.jolharg.com"
            "api.dev.jobfinder.jolharg.com"
            "jobfinder.jolharg.com"
            "api.jobfinder.jolharg.com"
            # "news.${domain}"
            # "grocy.${domain}"
            "degenerate.tsumikimikan.com"
          ];
        };
        # "dandart.geek" = {
        #   webroot = "/var/lib/acme/acme-challenge";
        #   server = "https://playground.acme.libre";
        # };
      };
    };

    # pam.usb.enable = true;
    # TODO pam phone fingerprint?

    isolate = {
      enable = true;
    };

    pam = {
      services = {
        # be explicit in case we want to turn it off
        gnupg = {
          enable = true;
          fprintAuth = true;
        };
        # login = {
        #   # not as required
        #   fprintAuth = false;
        # };
        # kde-fingerprint = {
        #   # not as required
        #   fprintAuth = lib.mkForce false;
        # };
      };
    };

    rtkit.enable = true;

    # when persist use persist here

    # We no longer need these but I'll just leave this here so we know how to do it

    #pki.certificateFiles = [
    #  "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"   
    #  # ../common/private/ca-bundle.crt
    #  ~/code/mine/nix/system/common/private/rootCA.pem
    #  ~/code/mine/nix/system/common/private/local-cert.pem
    #];

    pki.certificateFiles = [
      # OpenNIC
      # TODO script to download without SSL
      # TODO verify
      (pkgs.writeText "opennic_root_ca.crt" ''
        Certificate:
          Data:
              Version: 3 (0x2)
              Serial Number: 36 (0x24)
              Signature Algorithm: sha256WithRSAEncryption
              Issuer: DC=libre, DC=acme, DC=playground, O=OpenNIC, OU=OpenNIC CA, CN=OpenNIC Root CA
              Validity
                  Not Before: Oct 17 08:48:50 2025 GMT
                  Not After : Apr 17 08:48:50 2026 GMT
              Subject: DC=libre, DC=acme, DC=playground, O=OpenNIC, OU=OpenNIC CA, CN=OpenNIC Root CA
              Subject Public Key Info:
                  Public Key Algorithm: rsaEncryption
                      Public-Key: (4096 bit)
                      Modulus:
                          00:aa:0e:d0:3b:e6:08:ec:91:c5:d9:66:21:44:0b:
                          33:a0:f4:9b:99:f7:a0:5b:a5:f4:12:a1:85:dc:4c:
                          97:63:ee:02:07:d2:62:c6:44:f4:19:c6:68:c7:1f:
                          a2:f1:54:a1:76:d0:a7:42:8d:b1:27:42:fe:15:04:
                          48:e0:38:6d:d3:16:61:7d:21:07:f5:16:a1:9e:5e:
                          08:55:15:83:46:46:1d:b9:5b:d7:68:65:91:c6:44:
                          35:51:f9:40:26:e4:9b:89:b4:b8:8c:e7:bf:b7:60:
                          eb:b9:aa:23:e5:58:2a:45:1c:6c:b9:a9:30:fe:f0:
                          47:a5:10:4c:5c:86:58:bf:64:d2:29:e4:8d:e4:46:
                          85:c6:b6:03:27:2b:44:b1:e0:1c:6b:81:3d:2f:1b:
                          91:4e:40:1b:6b:8a:5d:1e:cb:4e:a8:be:dd:09:4b:
                          fb:23:d5:ff:d0:c9:1f:d4:08:69:3e:10:f7:99:62:
                          d3:ef:0c:aa:92:e9:62:97:c5:ff:79:38:3f:92:f4:
                          f6:4c:b0:0d:fb:82:9e:ba:cb:be:39:19:e4:9b:df:
                          82:de:63:55:25:a1:9a:28:ea:7f:37:2b:18:af:31:
                          46:b3:69:07:50:e3:10:6e:d3:7a:c1:77:65:bd:57:
                          7e:29:85:3c:30:f1:c6:f9:16:62:8d:b4:48:cb:e8:
                          76:1b:bb:ff:2b:ac:6a:5d:6f:b4:bb:95:62:87:19:
                          db:ad:91:b9:f0:98:df:4e:12:2f:ab:e2:10:94:4b:
                          1a:1a:4b:f8:46:66:1b:59:15:bc:38:3e:32:c3:7f:
                          c6:4c:e8:f5:d5:7f:60:69:f5:70:5b:12:14:70:50:
                          e8:f7:70:f2:7e:b4:1b:1d:3e:09:a6:07:34:36:5f:
                          54:78:86:13:dc:02:53:3c:fd:14:5d:ca:f5:96:6a:
                          5f:6e:bd:0f:db:d4:10:64:d4:36:b3:55:6a:f8:f6:
                          e4:f2:c0:84:50:ba:2f:5b:a0:11:0f:6a:ba:05:29:
                          e0:a2:53:ec:98:3a:7b:12:b4:30:72:b5:d8:5f:e8:
                          6c:b3:d8:0b:a9:46:7d:c8:63:7a:fa:c3:55:49:89:
                          9c:70:40:fa:8a:2f:2b:7d:4d:bd:7c:73:7b:39:ee:
                          26:8a:48:a0:3c:ff:0a:0a:fc:c0:d4:00:5f:ad:2a:
                          71:9e:a3:72:78:ef:f8:37:d1:05:77:a8:e5:b6:bb:
                          c8:67:82:91:41:2c:d5:e0:65:e6:5d:7c:7f:ee:f3:
                          99:ef:10:ce:9a:64:2a:69:a1:80:55:09:64:39:90:
                          5a:5b:6a:74:3d:76:32:53:20:cc:a5:cf:75:a4:ea:
                          c6:8f:bb:ab:04:88:2e:a4:aa:52:0b:90:47:37:e7:
                          bc:11:75
                      Exponent: 65537 (0x10001)
              X509v3 extensions:
                  X509v3 Key Usage: critical
                      Digital Signature, Certificate Sign, CRL Sign
                  X509v3 Basic Constraints: critical
                      CA:TRUE, pathlen:1
                  X509v3 Subject Key Identifier: 
                      A1:10:8C:9B:F4:59:3B:2F:F4:8A:B2:19:02:8F:82:94:E7:CC:6B:93
                  X509v3 Authority Key Identifier: 
                      A1:10:8C:9B:F4:59:3B:2F:F4:8A:B2:19:02:8F:82:94:E7:CC:6B:93
                  X509v3 Name Constraints: critical
                      Permitted:
                        DNS:.bbs
                        DNS:.chan
                        DNS:.cyb
                        DNS:.dyn
                        DNS:.geek
                        DNS:.gopher
                        DNS:.indy
                        DNS:.libre
                        DNS:.neo
                        DNS:.null
                        DNS:.o
                        DNS:.oss
                        DNS:.oz
                        DNS:.parody
                        DNS:.pirate
          Signature Algorithm: sha256WithRSAEncryption
          Signature Value:
            22:33:86:af:81:98:21:de:b9:d2:4a:b7:d8:49:7e:29:02:52:
            4a:59:fd:1b:30:a8:67:8d:e3:42:8b:aa:45:5f:20:2d:8f:f1:
            23:1a:a5:61:fe:08:e7:47:f2:63:26:2b:9d:9d:db:d6:2e:45:
            37:0a:a7:d9:97:57:7b:21:f8:78:77:92:84:b4:74:97:17:48:
            d4:a2:58:1e:6f:f4:ce:9f:3c:3d:74:a7:e8:8d:24:5f:ec:0b:
            f0:9f:a6:f5:b7:5a:91:5b:60:ae:5e:b1:49:f9:fa:3d:4d:c9:
            3c:c6:e7:50:bb:e8:2f:fb:6c:e9:71:d1:da:19:04:01:6b:73:
            05:f9:fa:cc:4d:da:f5:a2:d3:d6:ea:48:b7:aa:4f:e0:5b:73:
            dc:46:e4:94:06:4b:8c:b1:04:d8:ce:32:98:89:07:01:11:1d:
            69:df:6e:0d:c6:15:cf:95:3d:67:a0:28:e8:35:aa:7e:c3:db:
            41:a2:4c:19:0c:6a:24:0c:4b:44:5a:1b:1b:f0:c3:f9:8c:f4:
            9c:d4:29:64:73:05:6c:bb:44:07:c0:25:32:fa:4b:99:2b:f2:
            77:20:98:69:84:42:12:67:ad:fe:99:62:9a:e3:f5:f5:b4:16:
            b9:76:60:a6:e8:54:98:e0:cb:22:14:62:f5:d2:4e:36:f3:8b:
            b6:09:bc:ca:70:e9:d8:1c:36:82:5e:7a:92:56:c0:dd:1e:78:
            e3:77:db:dd:c9:9b:75:ff:b3:e4:65:a9:35:d7:80:4d:b0:cd:
            87:a9:c0:55:55:12:0e:c4:df:04:32:ec:ba:0b:44:2b:77:5f:
            a3:d7:8d:22:d4:e0:c7:86:3f:cc:ac:98:d7:c4:e8:a6:11:2a:
            c8:32:38:23:38:f9:3a:25:a8:5a:60:19:7f:6a:3b:ba:03:ea:
            46:ef:27:30:d5:0c:f5:1a:09:ff:76:12:03:a6:f2:49:0f:d6:
            42:80:a6:18:77:9c:58:95:6b:63:ce:2b:bb:81:c5:f4:34:a5:
            86:f4:de:cf:5c:b2:a6:56:d6:62:aa:64:c8:5f:31:28:85:0d:
            87:49:a0:44:4c:08:3c:ea:75:12:f9:94:7f:da:df:af:1f:aa:
            aa:82:f7:62:9f:d6:40:02:b9:0b:70:b9:2c:65:42:39:42:91:
            d0:36:9d:86:e5:a2:70:8a:7d:80:0d:a8:f0:f6:9f:c6:e0:9a:
            a4:4a:2d:d6:be:38:2c:00:53:b9:ef:6c:03:02:e6:71:ae:40:
            58:10:8e:44:54:4f:dc:8c:df:53:7f:25:7a:3f:a2:bc:fe:4c:
            c4:74:ef:ba:7a:dc:94:e3:82:68:53:a2:d0:68:aa:a2:c8:a3:
            58:74:19:1d:5a:67:5c:fa
      -----BEGIN CERTIFICATE-----
      MIIGkTCCBHmgAwIBAgIBJDANBgkqhkiG9w0BAQsFADCBijEVMBMGCgmSJomT8ixk
      ARkWBWxpYnJlMRQwEgYKCZImiZPyLGQBGRYEYWNtZTEaMBgGCgmSJomT8ixkARkW
      CnBsYXlncm91bmQxEDAOBgNVBAoMB09wZW5OSUMxEzARBgNVBAsMCk9wZW5OSUMg
      Q0ExGDAWBgNVBAMMD09wZW5OSUMgUm9vdCBDQTAeFw0yNTEwMTcwODQ4NTBaFw0y
      NjA0MTcwODQ4NTBaMIGKMRUwEwYKCZImiZPyLGQBGRYFbGlicmUxFDASBgoJkiaJ
      k/IsZAEZFgRhY21lMRowGAYKCZImiZPyLGQBGRYKcGxheWdyb3VuZDEQMA4GA1UE
      CgwHT3Blbk5JQzETMBEGA1UECwwKT3Blbk5JQyBDQTEYMBYGA1UEAwwPT3Blbk5J
      QyBSb290IENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAqg7QO+YI
      7JHF2WYhRAszoPSbmfegW6X0EqGF3EyXY+4CB9JixkT0GcZoxx+i8VShdtCnQo2x
      J0L+FQRI4Dht0xZhfSEH9Rahnl4IVRWDRkYduVvXaGWRxkQ1UflAJuSbibS4jOe/
      t2Druaoj5VgqRRxsuakw/vBHpRBMXIZYv2TSKeSN5EaFxrYDJytEseAca4E9LxuR
      TkAba4pdHstOqL7dCUv7I9X/0Mkf1AhpPhD3mWLT7wyqkulil8X/eTg/kvT2TLAN
      +4Keusu+ORnkm9+C3mNVJaGaKOp/NysYrzFGs2kHUOMQbtN6wXdlvVd+KYU8MPHG
      +RZijbRIy+h2G7v/K6xqXW+0u5VihxnbrZG58JjfThIvq+IQlEsaGkv4RmYbWRW8
      OD4yw3/GTOj11X9gafVwWxIUcFDo93DyfrQbHT4Jpgc0Nl9UeIYT3AJTPP0UXcr1
      lmpfbr0P29QQZNQ2s1Vq+Pbk8sCEULovW6ARD2q6BSngolPsmDp7ErQwcrXYX+hs
      s9gLqUZ9yGN6+sNVSYmccED6ii8rfU29fHN7Oe4mikigPP8KCvzA1ABfrSpxnqNy
      eO/4N9EFd6jltrvIZ4KRQSzV4GXmXXx/7vOZ7xDOmmQqaaGAVQlkOZBaW2p0PXYy
      UyDMpc91pOrGj7urBIgupKpSC5BHN+e8EXUCAwEAAaOB/zCB/DAOBgNVHQ8BAf8E
      BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUoRCMm/RZOy/0irIZ
      Ao+ClOfMa5MwHwYDVR0jBBgwFoAUoRCMm/RZOy/0irIZAo+ClOfMa5MwgZUGA1Ud
      HgEB/wSBijCBh6CBhDAGggQuYmJzMAeCBS5jaGFuMAaCBC5jeWIwBoIELmR5bjAH
      ggUuZ2VlazAJggcuZ29waGVyMAeCBS5pbmR5MAiCBi5saWJyZTAGggQubmVvMAeC
      BS5udWxsMASCAi5vMAaCBC5vc3MwBYIDLm96MAmCBy5wYXJvZHkwCYIHLnBpcmF0
      ZTANBgkqhkiG9w0BAQsFAAOCAgEAIjOGr4GYId650kq32El+KQJSSln9GzCoZ43j
      QouqRV8gLY/xIxqlYf4I50fyYyYrnZ3b1i5FNwqn2ZdXeyH4eHeShLR0lxdI1KJY
      Hm/0zp88PXSn6I0kX+wL8J+m9bdakVtgrl6xSfn6PU3JPMbnULvoL/ts6XHR2hkE
      AWtzBfn6zE3a9aLT1upIt6pP4Ftz3EbklAZLjLEE2M4ymIkHAREdad9uDcYVz5U9
      Z6Ao6DWqfsPbQaJMGQxqJAxLRFobG/DD+Yz0nNQpZHMFbLtEB8AlMvpLmSvydyCY
      aYRCEmet/plimuP19bQWuXZgpuhUmODLIhRi9dJONvOLtgm8ynDp2Bw2gl56klbA
      3R5443fb3cmbdf+z5GWpNdeATbDNh6nAVVUSDsTfBDLsugtEK3dfo9eNItTgx4Y/
      zKyY18TophEqyDI4Izj5OiWoWmAZf2o7ugPqRu8nMNUM9RoJ/3YSA6bySQ/WQoCm
      GHecWJVrY84ru4HF9DSlhvTez1yyplbWYqpkyF8xKIUNh0mgREwIPOp1EvmUf9rf
      rx+qqoL3Yp/WQAK5C3C5LGVCOUKR0DadhuWicIp9gA2o8PafxuCapEot1r44LABT
      ue9sAwLmca5AWBCORFRP3IzfU38lej+ivP5MxHTvunrclOOCaFOi0GiqosijWHQZ
      HVpnXPo=
      -----END CERTIFICATE-----


      '')
    ];

    chromiumSuidSandbox.enable = true;

    # allowUserNamespaces = true;
    # unprivilegedUsernsClone = true;
  };
}
