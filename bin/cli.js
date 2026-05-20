#!/usr/bin/env node
'use strict';

const fs   = require('fs');
const path = require('path');

const [,, command, flag] = process.argv;

if (command !== 'install' || flag !== '--skills') {
  console.error('Usage: visual-explainer install --skills');
  process.exit(1);
}

const src  = path.resolve(__dirname, '..', '.github', 'skills', 'visual-explainer');
const dest = path.resolve(process.cwd(), '.github', 'skills', 'visual-explainer');

if (!fs.existsSync(src)) {
  console.error(`Source skill not found: ${src}`);
  process.exit(1);
}

copyDir(src, dest);
console.log(`Visual Explainer skill installed to: ${dest}`);

function copyDir(from, to) {
  fs.mkdirSync(to, { recursive: true });
  for (const entry of fs.readdirSync(from, { withFileTypes: true })) {
    const srcPath  = path.join(from, entry.name);
    const destPath = path.join(to,   entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}
