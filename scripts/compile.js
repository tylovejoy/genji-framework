const fs = require("fs");
const path = require("path");
const overpy = require("./overpy_standalone");

const OUTPUT_DIR = path.resolve(__dirname, "../dist");

// Get entrypoint file from CLI or default
const entryFile = process.argv[2] || path.resolve(__dirname, "../main.opy");

function ensureOutputDir() {
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }
}

function main() {
  if (!fs.existsSync(entryFile)) {
    console.error(`❌ Entry file not found: ${entryFile}`);
    process.exit(1);
  }

  console.log(`📦 Compiling entrypoint: ${entryFile}`);
  try {
    const compiled = overpy.compileFile(entryFile);  // compileFile is correct here for standalone
    ensureOutputDir();

    const baseName = path.basename(entryFile, ".opy");
    const outputPath = path.join(OUTPUT_DIR, `${baseName}.ow`);
    fs.writeFileSync(outputPath, compiled);

    console.log(`✅ Output written to ${outputPath}`);
  } catch (err) {
    console.error(`❌ Compilation failed: ${err.message}`);
    process.exit(1);
  }
}

main();
