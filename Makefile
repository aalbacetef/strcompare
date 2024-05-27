test:
	zig build test

clean:
	rm -rf ./zig-cache

lint:
	zig fmt --check .
