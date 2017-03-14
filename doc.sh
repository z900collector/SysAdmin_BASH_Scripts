#!/bin/bash
#
#
# Documentation CRON job
#

BIN=/usr/local/bin/doxygen/bin
TODAY=`date '+%Y-%m-%d'`




#------------------------------------------------------------
#
#
# Document DRS DEV image
#
#
#
LOGNAME="drs-docs"
SRC=/var/www/vhosts/p-and-f-holdings.com/dev/app
cd ${SRC}
if [ -a drs.dox.template ]
then
	cp drs.dox.template drs.dox
	rm -f drs.lines
	find . -type f -name "*.php" | wc -l > drs.filecnt
	for F in `find . -type f -name "*.php"`
	do
		wc -l ${F} | cut -d'.' -f1 >> drs.lines
	done
	cat drs.lines | perl -nle '$sum += $_ } END { print $sum' > drs.total

	sed -i "s/BUILDDATE/`date`/g" drs.dox
	sed -i "s/DRSLINES/`cat drs.total`/g" drs.dox
	sed -i "s/DRSFILECNT/`cat drs.filecnt`/g" drs.dox
	lines=`cat drs.total`
	perline=4.6
	res=`echo "$lines * $perline" | bc`
	printf "$%'.2f" $res > drs.cost
	sed -i "s/COST/`cat drs.cost`/g" drs.dox
fi
echo " "  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
echo "-------- START--------"  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
${BIN}/doxygen drs.conf >> /logs/${LOGNAME}-${TODAY}.log 2>&1
echo " "  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
#
# phpDocumentor 2
#
cd ${SRC}
LOGNAME="drs-phpdocumentor2"
/usr/local/bin/phpDocumentor -d . --ignore=vendor/* -t /var/www/vhosts/p-and-f-holdings.com/wordpress/drs/phpDoc >> /logs/${LOGNAME}-${TODAY}.log 2>&1



#------------------------------------------------------------
#
# Document the store
#
#
SRC=/var/www/vhosts/rockabillydames.com/store/app
LOGNAME="lv5cart-docs"

cd ${SRC}
NOW=`date`
if [ -a store.dox.template ]
then
	cp store.dox.template store.dox
	sed -i "s/BUILDDATE/`date`/g" store.dox
fi
echo " "  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
echo "-------- START--------"  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
${BIN}/doxygen store.conf >> /logs/${LOGNAME}-${TODAY}.log 2>&1
echo " "  >> /logs/${LOGNAME}-${TODAY}.log 2>&1
#
# phpDocumentor 2
#
SRC=/var/www/vhosts/rockabillydames.com/store/app
LOGNAME="lv5cart-phpdocumentor2"
cd ${SRC}
/usr/local/bin/phpDocumentor -d . --ignore=vendor/* -t /var/www/vhosts/p-and-f-holdings.com/wordpress/lv5cart/phpDoc >> /logs/${LOGNAME}-${TODAY}.log 2>&1

/usr/local/bin/phpmetrics --report-html=/var/www/vhosts/p-and-f-holdings.com/wordpress/lv5cart/metrics.html ${SRC}  >> /logs/${LOGNAME}-${TODAY}.log 2>&1

