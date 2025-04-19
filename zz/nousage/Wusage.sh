#!/usr/local/bin/zsh
# setup for webmasters
# creates links from login directory
# sets ownership to /vhost/www dirs


wdh=(bambi chdc fcs iak tf tracs tslw ycc)
cgd=(frefau froggy paw poohe sfc)
mln=(minlin)
gem=(fosc mons pamo)
    
echo doing Wwdh
for each in $wdh; do
    ln -s /vhost/www/$each/ber /home/Wwdh/$each
    chown -R wdh:wdh /vhost/www/$each
done

echo doing Wcgd
for each in $cgd; do
    ln -s /vhost/www/$each/ber /home/Wcgd/$each
    chown -R cgd:cgd /vhost/www/$each
done

echo doing Wmln
for each in $mln; do
    ln -s /vhost/www/$each/ber /home/Wmln/$each
    chown -R mln:mln /vhost/www/$each
done

echo doing Wgem
for each in $gem; do
    ln -s /vhost/www/$each/ber /home/Wgem/$each
    chown -R gem:gem /vhost/www/$each
done
