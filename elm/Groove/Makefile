launch: run
	elm reactor --port 8001
run: kill
	elm make src/PhotoGroove.elm --output app.js
kill: def
	lsof -i :8001 | awk 'NR!=1 {print $2}' | xargs kill
def:
	echo "Done"
