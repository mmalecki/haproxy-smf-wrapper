CC=gcc

all: haproxy-smf-wrapper

clean:
	rm -f haproxy-smf-wrapper

haproxy-smf-wrapper: haproxy-smf-wrapper.c
	$(CC) $< -o $@

.PHONY: clean
