# Compile examples
chpl -o examples/singleProducerConsumer -M ./src examples/singleProducerConsumer.chpl
chpl -o examples/multipleProducerConsumer -M ./src examples/multipleProducerConsumer.chpl
echo "Compiled examples"
# Compile tests
chpl -o tests/main -M ./src tests/main.chpl
echo "Compiled tests"