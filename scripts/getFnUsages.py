f = open('/home/kwanghyun_su/pk_base_usage.txt')

fnNames = []

"""
test = 'sadasd base::hi'
pos = test.find('//')
bp = test.find('base::')
print('pos is' + str(pos))
print('bp is' + str(bp))
"""



for line in f :
    pos1 = line.find('base::')
    commentPos = line.find('//')
    if commentPos != -1 and commentPos < pos1 :
        continue

    qtPos = line.find('\"')
    if qtPos != -1 and qtPos < pos1 :
        continue

    unittestPos = line.find('unittest')
    if unittestPos == 1 :
        print("Found unittest. Continuing...", line)
        continue

    if pos1 == -1 :
        print("found outlier")
        print(pos1, ", ", pos2, ", ", fnname, ", ", line)
        continue

    pos2 = len(line) # Begin with the length of the current line

    blankPos = line.find(' ', pos1)
    if blankPos != -1 and blankPos < pos2 :
        pos2 = blankPos

    openParenPos = line.find('(', pos1)
    if openParenPos != -1 and openParenPos < pos2 :
        pos2 = openParenPos

    closeParenPos = line.find(')', pos1)
    if closeParenPos != -1 and closeParenPos < pos2 :
        pos2 = closeParenPos

    ampPos = line.find('&', pos1)
    if ampPos != -1 and ampPos < pos2 :
        pos2 = ampPos

    asteriskPos = line.find('*', pos1)
    if asteriskPos != -1 and asteriskPos < pos2 :
        pos2 = asteriskPos

    commaPos = line.find(',', pos1)
    if commaPos != -1 and commaPos < pos2 :
        pos2 = commaPos

    semiColonPos = line.find(';', pos1)
    if semiColonPos != -1 and semiColonPos < pos2 :
        pos2 = semiColonPos

    openBracketPos = line.find('<', pos1)
    if openBracketPos != -1 and openBracketPos < pos2 :
        pos2 = openBracketPos

    closeBracketPos = line.find('>', pos1)
    if closeBracketPos != -1 and closeBracketPos < pos2 :
        pos2 = closeBracketPos
    
    # Cut from pos1 to pos2 
    fnName = line[pos1:pos2]

    # List the api name if unique 
    if not fnName in fnNames :
        fnNames.append(fnName)

f.close()

with open('/home/kwanghyun_su/pk_base_usage_unique_new.txt', 'w') as of :
    for name in fnNames :
        of.write(name + "\n")

