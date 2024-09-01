#!/usr/bin/env node

new Promise((resolve, reject) => {
  const binary = Array.from(
    new TextEncoder().encode(process.argv[1])
  )
    .map((byte) => byte.toString(2).padStart(8, "0"))
    .join(" ");
  console.log(binary);
  return binary;
});
