#!/bin/bash

TARGET="https://your-site-placeholder.com"
OUTPUT="security_audit_report.txt"

echo "==================================================" > $OUTPUT
echo "Security Assessment Report for: $TARGET" >> $OUTPUT
echo "Date: $(date)" >> $OUTPUT
echo "==================================================" >> $OUTPUT
echo "" >> $OUTPUT

# Test 1: Exposed Config Files
echo "### TEST 1: Checking for Exposed Configuration Files ###" >> $OUTPUT
echo "" >> $OUTPUT
for file in wp-config.php .env wp-config.php.bak .git/config config.php .htaccess phpinfo.php
do
    echo "Testing: $TARGET/$file" >> $OUTPUT
    curl -I -s $TARGET/$file | head -n 1 >> $OUTPUT
    echo "" >> $OUTPUT
done

# Test 2: XML-RPC Status
echo "### TEST 2: XML-RPC Exploitation Check ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -X POST $TARGET/xmlrpc.php -d '<?xml version="1.0"?><methodCall><methodName>system.listMethods</methodName></methodCall>' -s >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 3: Directory Listing
echo "### TEST 3: Directory Listing Check ###" >> $OUTPUT
echo "" >> $OUTPUT
for dir in wp-content/uploads/ wp-content/plugins/ wp-content/themes/ wp-includes/
do
    echo "Testing directory: $TARGET/$dir" >> $OUTPUT
    curl -s $TARGET/$dir | grep -i "Index of" >> $OUTPUT
    if [ $? -eq 0 ]; then
        echo "WARNING: Directory listing enabled!" >> $OUTPUT
    else
        echo "OK: Directory listing disabled" >> $OUTPUT
    fi
    echo "" >> $OUTPUT
done

# Test 4: User Enumeration
echo "### TEST 4: WordPress User Enumeration ###" >> $OUTPUT
echo "" >> $OUTPUT
echo "Testing: $TARGET/?author=1" >> $OUTPUT
curl -I -s $TARGET/?author=1 | grep -E "HTTP|Location" >> $OUTPUT
echo "" >> $OUTPUT
echo "Testing: $TARGET/wp-json/wp/v2/users" >> $OUTPUT
curl -s $TARGET/wp-json/wp/v2/users | head -n 20 >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 5: WooCommerce API Endpoints
echo "### TEST 5: WooCommerce API Exposure ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -s $TARGET/wp-json/wc/v3/products >> $OUTPUT
echo "" >> $OUTPUT
curl -s $TARGET/wp-json/wc/v3/customers >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 6: WordPress Version Detection
echo "### TEST 6: Version Information Exposure ###" >> $OUTPUT
echo "" >> $OUTPUT
echo "WordPress Version:" >> $OUTPUT
curl -s $TARGET/ | grep -oP 'wp-content.*?ver=\K[0-9.]+' | head -n 3 >> $OUTPUT
echo "" >> $OUTPUT
echo "Generator Tag:" >> $OUTPUT
curl -s $TARGET/ | grep -i "generator" >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 7: readme.html exposure
echo "### TEST 7: WordPress readme.html Exposure ###" >> $OUTPUT
curl -I -s $TARGET/readme.html | head -n 1 >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 8: robots.txt and sitemap
echo "### TEST 8: robots.txt and Sitemap Check ###" >> $OUTPUT
echo "" >> $OUTPUT
echo "robots.txt:" >> $OUTPUT
curl -s $TARGET/robots.txt >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 9: Security Headers Check
echo "### TEST 9: Security Headers Analysis ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -I -s $TARGET | grep -E "X-Frame|X-Content-Type|X-XSS|Strict-Transport|Content-Security|Referrer-Policy|Permissions-Policy" >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 10: Plugin Detection
echo "### TEST 10: Installed Plugins Detection ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -s $TARGET/ | grep -oP 'wp-content/plugins/\K[^/]+' | sort -u >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 11: Theme Detection
echo "### TEST 11: Active Theme Detection ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -s $TARGET/ | grep -oP 'wp-content/themes/\K[^/]+' | sort -u >> $OUTPUT
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 12: Login Page Protection
echo "### TEST 12: Login Rate Limiting Test ###" >> $OUTPUT
echo "" >> $OUTPUT
echo "Attempting 5 rapid login requests..." >> $OUTPUT
for i in {1..5}; do
    response=$(curl -X POST $TARGET/wp-login.php -d "log=testuser&pwd=testpass$i" -s -o /dev/null -w "%{http_code}")
    echo "Attempt $i: HTTP $response" >> $OUTPUT
done
echo "" >> $OUTPUT
echo "" >> $OUTPUT

# Test 13: Cloudflare Trace
echo "### TEST 13: Cloudflare Information Leak ###" >> $OUTPUT
echo "" >> $OUTPUT
curl -s $TARGET/cdn-cgi/trace >> $OUTPUT
echo "" >> $OUTPUT

echo "==================================================" >> $OUTPUT
echo "Assessment Complete!" >> $OUTPUT
echo "==================================================" >> $OUTPUT

echo "Report saved to: $OUTPUT"
cat $OUTPUT
