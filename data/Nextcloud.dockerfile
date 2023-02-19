FROM nextcloud

RUN mkdir -p /opt/nextcloud/data; \
	chown -R www-data:root /opt/nextcloud/data; \
	chmod -R g=u /opt/nextcloud/data

VOLUME /opt/nextcloud/data

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]