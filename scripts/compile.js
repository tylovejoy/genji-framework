const fs = require("fs/promises");
const path = require("path");
const overpy = require("./overpy_standalone");

const OUTPUT_DIR = path.resolve(__dirname, "../dist");

const entryPath = path.resolve(process.argv[2] || path.resolve(__dirname, "../framework.opy"));

async function ensureOutputDir() {
  try {
    await fs.mkdir(OUTPUT_DIR, { recursive: true });
  } catch (e) {
    console.error(`Failed to create output directory: ${e.message}`);
    process.exit(1);
  }
}

async function main() {
  try {
    const source = await fs.readFile(entryPath, "utf-8");

    console.log(`Compiling: ${entryPath}`);

    await overpy.readyPromise;
    compiled = (await overpy.compile(source, "en-US", path.dirname(entryPath), 'framework.opy')).result;

    await ensureOutputDir();

    const outPath = path.join(
      OUTPUT_DIR,
      path.basename(entryPath, ".opy") + ".ow"
    );

    await fs.writeFile(outPath, compiled);
    console.log(`Output written to ${outPath}`);
  } catch (err) {
    console.error(`Compilation failed: ${err.message}`);
    process.exit(1);
  }
}

main();
