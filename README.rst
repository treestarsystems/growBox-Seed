************
growBox-Seed
************
Install script for all growBox projects

PLEASE NOTE:
############
This is meant to be ran on a newly installed system that does
not have things like git and other necessary tools. I suggest
wget or copy+paste the growBox-Seed.sh script.

Example of retrieval:
#####################
For certificate issues use "wget --no-check-certificate"

.. code-block:: bash
    :linenos:
	wget https://raw.githubusercontent.com/mjnshosting/growBox-Seed/master/growBox-Seed.sh
	chmod +x growBox-Seed.sh
	sudo ./growBox-Seed.sh -i -b <username> <password-for-user>

username and password are optional

cURL may need to be installed when using minimal versions of an OS.

.. code-block:: bash
    :linenos:
	curl https://raw.githubusercontent.com/mjnshosting/growBox-Seed/master/growBox-Seed.sh -o growBox-Seed.sh
	chmod +x growBox-Seed.sh
	sudo ./growBox-Seed.sh -i -b <username> <password-for-user>

username and password are optional

Code Sources:
=============
`<https://unix.stackexchange.com/a/387912>`_
`<https://stackoverflow.com/a/15420946>`_
`<https://stackoverflow.com/a/27658717>`_
`<https://stackoverflow.com/a/6212408>`_
`<https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html>`_
`<https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/>`_
