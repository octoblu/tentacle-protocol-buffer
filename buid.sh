for p in *.proto; do
  pb=${p%.*}.pb
  protoc $p -o $pb
  python ../nanopb/generator/nanopb_generator.py $pb
done
