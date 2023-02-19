ARG NEXTCLOUD_DATA_DIR=/opt/nextcloud/data
ARG IMAGE_TAG=fpm-alpine

FROM nextcloud:${IMAGE_TAG}

ARG NEXTCLOUD_DATA_DIR

RUN mkdir -p ${NEXTCLOUD_DATA_DIR}; \
	chown -R www-data:root ${NEXTCLOUD_DATA_DIR}; \
	chmod -R g=u ${NEXTCLOUD_DATA_DIR}

VOLUME ${NEXTCLOUD_DATA_DIR}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]