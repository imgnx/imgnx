npm run build
cd ./dist
git add-commit "Publish"
git push -u origin main
git log > ../versions.txt
cd ../