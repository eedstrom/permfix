install: permfix.sh
	cp permfix.sh /usr/local/bin/permfix
	chmod 00755 /usr/local/bin/permfix

uninstall:
	rm /usr/local/bin/permfix
