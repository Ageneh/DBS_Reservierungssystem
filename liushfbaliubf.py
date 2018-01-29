'''
Created on 29.01.2018

@author: hareg001
'''

string = "INSERT INTO platz(saalName, reihe, sitz) VALUES(\'{}\', {}, {});"

def reihen(saal, reihe, plaetze):
    capitolR = [r for r in range(1, reihe+1)]
    capitolP = [p for p in range(1, plaetze +1)]
    
    for r in capitolR:
        for p in capitolP:
            print(string.format(saal, r, p))

    return

reihen('Capitol', 10, 3)
#reihen('Empire', 50, 25)
#reihen('Omnipa', 55, 20)
#reihen('Lounge', 20, 25)
#reihen('Atlantis', 50, 25)
