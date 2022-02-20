lable = []
predict = []

with open('predict.txt') as file:
    for line in file:
        predict.append(int(line.rstrip()))

with open('te_lable_sm.dat') as file:
    for line in file:
        lable.append(int(line.rstrip()))

correct = 0

for i in range(0,750):
    if lable[i] == predict[i]:
        correct += 1

print('Accuracy = ' + str((correct / 750) * 100.0))
