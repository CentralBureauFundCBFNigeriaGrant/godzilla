# Godzilla Programme
Zero-subscription tunnel via VLESS+TLS SNI spoofing.

## Server setup
bash server/setup.sh
bash server/gen-keys.sh

## Test procedure
- **Test A**: Turn off data. Open Chrome. Should fail.
- **Test B**: Connect v2rayNG. Open Chrome. If it loads → WORKS.
- **Test C**: If B fails, edit DOMAIN in gen-keys.sh to `www.airtel.com`, rerun.
