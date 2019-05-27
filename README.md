# growBox-Seed
Install script for all growBox projects

## PLEASE NOTE:  
This is meant to be ran on a newly installed system that does  
not have things like git and other necessary tools. I suggest  
wget or copy+paste the growBox-Seed.sh script.

#### Example of retrieval:  
**For certificate issues use "wget --no-check-certificate"**
```
wget https://raw.githubusercontent.com/mjnshosting/growBox-Seed/master/growBox-Seed.sh
chmod +x growBox-Seed.sh
sudo ./growBox-Seed.sh -i -b <username> <password-for-user>
```
cURL may need to be installed when using minimal versions of an OS.
```
curl https://raw.githubusercontent.com/mjnshosting/growBox-Seed/master/growBox-Seed.sh -o growBox-Seed.sh
chmod +x growBox-Seed.sh
sudo ./growBox-Seed.sh -i -b <username> <password-for-user>
```

#### Code Sources:
https://unix.stackexchange.com/a/387912
https://stackoverflow.com/a/15420946
https://stackoverflow.com/a/27658717
https://stackoverflow.com/a/6212408
https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html
https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
