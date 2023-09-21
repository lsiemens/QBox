README="./README.md"
LICENSE="../../LICENSE"
USERGUIDE="../../Documentation/PCUserGuide.md"

TARGET="./QBox"

package:
	cp $(README) $(TARGET)/README.txt
	cp $(LICENSE) $(TARGET)/LICENSE.txt
	cp $(USERGUIDE) $(TARGET)/UserGuide.txt

	zip $(TARGET).zip $(TARGET) -r

clean:
	rm $(TARGET)/*.txt $(TARGET).zip -rf
