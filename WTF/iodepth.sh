for iodepth in 1 2 4 8 16 32; do 
    sed -i "/^iodepth/c iodepth=${iodepth}" fio.conf && fio fio.conf | tee 2hdd/rbd_i$(printf "%02d" ${iodepth}).log && sleep 20s
done
