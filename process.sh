#!/bin/bash

# Source and descriptions http://www.cboe.com/products/vix-index-volatility/volatility-indexes
destination_folder="temp-output-directory"
mkdir $destination_folder/alternative/cboe -p

try_cboe_download() {
    link_download="https://cdn.cboe.com/api/global/us_indices/daily_prices/$1_History.csv"
	echo ${link_download}
    output_destination="${destination_folder}/alternative/cboe/$2.csv"
    i=1
    while [ "$i" -le "5" ]; do
        wget ${link_download} -O ${output_destination} && echo "Downloaded $2 successfully" && sleep 5 && return

        echo "Failed to download file: $2 ($i / 5)"
        i=$((i+1))
        sleep 10
    done;

    echo "Failed to download data from $link_download (5 / 5) - Exiting"
    exit 1
}

try_cboe_download VIX vix
try_cboe_download VXN vxn
try_cboe_download VXO vxo
try_cboe_download RVX rvx
try_cboe_download TYVIX tyvix
try_cboe_download VIX3M vix3m
try_cboe_download VIX6M vix6m
try_cboe_download VIX9D vix9d

echo "Uploading CBOE data files to cache bucket"
#aws s3 sync $destination_folder/ s3://cache.quantconnect.com/