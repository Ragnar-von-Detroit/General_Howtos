# How To

## Add proxy

```
#best is to do this in the .bashrc or initial shell setup
export http_proxy=http://<ip>[:<port>]
export https_proxy=http://<ip>[:<port>]
```

## Add a cacert

```
cd /etc/ssl/certs
wget http://curl.haxx.se/ca/cacert.pem
```

## Force usage of ssl version 3

```
curl -3 https://foo.bar
```

## Fllow insecure ssl

```
curl [-k|--insecure] <url>
```

## Add http status code output to response

```
#http://superuser.com/questions/272265/getting-curl-to-output-http-status-code
curl -i <url>
#or if you want to just have the http status code
curl -sw '\nhttp status code: %{http_code}' <url>
```

# Links

* http://curl.haxx.se/docs/httpscripting.html
