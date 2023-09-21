README="./README.md"
LICENSE="../../LICENSE"
USERGUIDE="../../Documentation/PCUserGuide.md"

TARGET="./QBox"

package:
	cp $(README) $(TARGET)/README.txt
	cp $(LICENSE) $(TARGET)/LICENSE.txt
	cp $(USERGUIDE) $(TARGET)/UserGuide.txt

	tar -czvf $(TARGET).tar.gz $(TARGET)

clean:
	rm $(TARGET)/*.txt $(TARGET).tar.gz -rf
