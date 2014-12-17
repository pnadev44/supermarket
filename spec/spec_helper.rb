require 'chefspec'
require 'chefspec/berkshelf'

require 'json'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |c|
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true
end

def configure_chef
  RSpec.configure do |config|
    config.platform = 'ubuntu'
    config.version = '14.04'
    config.log_level = :error
  end
end

def get_databag_item(name, item)
  filename = File.join('.', 'data_bags', name, "#{item}.json")
  { item => JSON.parse(IO.read(filename)) }
end

dummy_ssl_cert = <<EOF
-----BEGIN CERTIFICATE-----
MIIEBjCCAu4CCQD2dsoGHTvwBDANBgkqhkiG9w0BAQUFADCBxDELMAkGA1UEBhMC
VVMxCzAJBgNVBAgMAldBMRAwDgYDVQQHDAdTZWF0dGxlMRcwFQYDVQQKDA5NeSBT
dXBlcm1hcmtldDETMBEGA1UECwwKT3BlcmF0aW9uczFIMEYGA1UEAww/c3VwZXJt
YXJrZXQtaW5zdGFuY2UtdWJ1bnR1LTE0MDQtY3dlYmJlci1sNnFrcHhlZS1vcHNh
bG90LmxvY2FsMR4wHAYJKoZIhvcNAQkBFg95b3VAZXhhbXBsZS5jb20wHhcNMTQx
MTE4MjAwODEwWhcNMjQxMTE1MjAwODEwWjCBxDELMAkGA1UEBhMCVVMxCzAJBgNV
BAgMAldBMRAwDgYDVQQHDAdTZWF0dGxlMRcwFQYDVQQKDA5NeSBTdXBlcm1hcmtl
dDETMBEGA1UECwwKT3BlcmF0aW9uczFIMEYGA1UEAww/c3VwZXJtYXJrZXQtaW5z
dGFuY2UtdWJ1bnR1LTE0MDQtY3dlYmJlci1sNnFrcHhlZS1vcHNhbG90LmxvY2Fs
MR4wHAYJKoZIhvcNAQkBFg95b3VAZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQD70fgg0gkNNmJIjABNFSiHHcYXuxHArGbZh01VXN3U
TLN1zEm6pnjN5ghLFszuuYKp46VZxh/g+iMAH/PVLwmEtG1MBqUH7ni9XhL1ns49
a0tYB+Omb7zQbSDx67f8ZwpWLzo3c1mgAsH3FEMv5COdBC04bYDhd1EMYwuH4wW4
w/wW7VUCuzxU5z2M3Yd8XuolMl4eNNQFPqn5MhyBISWUYCXVVV+4T4L1l1obQyCL
cq0+RSpaQD6jWeeTBYlNSJ2wNMcXXhUAamTv23aPNw3mZd5Gla2bi3cEEWZTGoBf
elCcLJxBwLaG6AbMFNr0/mGuiyIRwAEH9V+nCSD3W56VAgMBAAEwDQYJKoZIhvcN
AQEFBQADggEBACHvJR6hAKli53gqXeLfUnf1JwsVhIRQupdDrx1goTumGou46cC1
fNWHhWsYB2EITUyKMuLTkQHjmuiBQcCGjLsc5rxo10wSqe8XvZDas+pKvBR/Ivox
jjyJBsNTAcKAcoLboCEjVj5cQRRdqhKpVBQPUsvrzcCEuvu1Mcnvpm41qcbo5vn0
SO1aO/XtrJNneTqhpv3L0tahd5lSi9zWhy9TuPOhrCuxRSFcxTqQ3MJYyK/hm2Oe
/w7gw7buSey+GOcI1DJV47DTOnr8T74Xuwl2iIG8KRYYvO/M5wYt61IzCuFwLcDV
IVNDTwdjokrMBkQ6ZYL3yDFmDEuGE5vWCpI=
-----END CERTIFICATE-----
EOF

dummy_ssl_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA+9H4INIJDTZiSIwATRUohx3GF7sRwKxm2YdNVVzd1EyzdcxJ
uqZ4zeYISxbM7rmCqeOlWcYf4PojAB/z1S8JhLRtTAalB+54vV4S9Z7OPWtLWAfj
pm+80G0g8eu3/GcKVi86N3NZoALB9xRDL+QjnQQtOG2A4XdRDGMLh+MFuMP8Fu1V
Ars8VOc9jN2HfF7qJTJeHjTUBT6p+TIcgSEllGAl1VVfuE+C9ZdaG0Mgi3KtPkUq
WkA+o1nnkwWJTUidsDTHF14VAGpk79t2jzcN5mXeRpWtm4t3BBFmUxqAX3pQnCyc
QcC2hugGzBTa9P5hrosiEcABB/Vfpwkg91uelQIDAQABAoIBAQCElRsn5I3BeBWt
DpEGBJLO+N0YF3UUVXDdLMCJphhhM3T1G3biH83Q0kEhj8KcGe3ylpmzN34HTItr
AGe3oUlIplo5QfJXx7WoNkSTL2Z0re4ATj8MnR3zOtGyraGz8Whe0gS7ty7D8U/A
T9nD+EDL5awNXpIRo2l3tRoYFG4pxXKzK4CSNLdbXTuOCHwngOrDhRF5fk8PDdoJ
bGyoOJQ9cqcxnsU7xgJBxfv1OtdmeKgKDgI9iSeZgvXGCw1uZDg5RC3bgOxp4e/J
thC62lFhso+l+1hWMQDepAzxqRureSF5yiJq52Xx1nAB2UCe6y48y4EAIiSnixe1
42VLFg6BAoGBAP4EoAiMqGZ+5hBgXP0qd7Dv8/HzNiLczmobeGBZG4etEme+LVUy
pXu+EGtg6FGLm/4H1gsXEV6o2cxwhhb59baH9oDgH5dpPFa4EUonesoIY5IED/7x
goFnHAkZDHPbxDa4bUgKhOJtTJutyLjDpaZOzdpoXrxgOlmxrMYJjjshAoGBAP3I
9D9thkYrcJ0ZH3GTsj+QIWYK/XEGCUcLvlWUtjDRkPDnEp93W65Z5gTo6WqC3nLU
bQcYES6lnO9Ythm1A+YKbCV4QL09zjG+ZcuueEf2Z14GXB4TFqtwPlIEu4t12o1X
M18R3U8QeKGBqTgOUIZuPvCMRBFWvKOHIfjX5Aj1AoGAUZ+k2PpxxnWyccK1Prid
u2JvjeisFanEPj5TgQpBGWjYyDNJF95tZITfe9Go9UMaPhfAhNHFyBgT3Giv/cQW
W6/22tSp8hpjxC3jiGOFRlRJworBpRdv6yr5zEabRMNymm7K1uJibuvWORQvsodT
vEwIQ81T285EEbxRG1XIuWECgYEAjqeyHCFNtA3hDH29vhM+xBoZnAmbczfoaSZB
xEuGqiRy6+eIAVmPkI76DFJ8OqH7tuKPssgliGoRsDzWh9bHrTy4k8tn4LhoOnAD
Op4FALaSXjkG+OTT/mRms6XzYi5KPt8AgnVBSJtCo86Ft3vcaeR4vrCp5nEyMl3Y
i8+XYC0CgYAxr/dPUSM2CMgV+uEENJBpNo/YpgukuTa5mNSLyVUfjxShwYZwgXwm
bhyjcuvPgry0hINiOS09Bv0knE58vuLXHTB9RCDOx8u0tH7XpdFzkObIONNGqw1T
lorovCeCU9FfwOS5LxMDQyApyFg6KfieoRPM4BFKeWAIrk4JBJ1Nqg==
-----END RSA PRIVATE KEY-----
EOF
