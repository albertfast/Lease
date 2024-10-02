import { LightningElement, track } from 'lwc';

export default class BitManipulationEncoderDecoder extends LightningElement {
    @track inputText = '';
    @track binaryString = '';
    @track decodedRaw = '';
    @track encodedValue = '';
    @track encodedBinary = '';
    @track decodedText = '';

    handleInputChange(event) {
        this.inputText = event.target.value;
    }

    textToBinary(text) {
        return text.split('').map(char => char.charCodeAt(0).toString(2).padStart(8, '0')).join('');
        
       
    }
    

    applyBitManipulation(binaryString) {
        if (binaryString.length !== 32) {
            throw new Error("Binary string must be exactly 32 bits long.");
        }

        const manipulatedBits = new Array(32);
        const bitMap = [
            0, 8, 16, 24,    
            1, 9, 17, 25,    
            2, 10, 18, 26,   
            3, 11, 19, 27,   
            4, 12, 20, 28,   
            5, 13, 21, 29,   
            6, 14, 22, 30,   
            7, 15, 23, 31    
        ];

        bitMap.forEach((bitIndex, i) => {
            manipulatedBits[i] = binaryString[bitIndex];
        });

        return manipulatedBits.join('');
    }

    reverseBitManipulation(encodedBinary) {
        if (encodedBinary.length !== 32) {
            throw new Error("Binary string must be exactly 32 bits long.");
        }

        const reversedBits = new Array(32);
        const bitMap = [
            0, 8, 16, 24,    // İlk byte'ı en başa alır
            1, 9, 17, 25,    
            2, 10, 18, 26,   
            3, 11, 19, 27,   
            4, 12, 20, 28,   
            5, 13, 21, 29,   
            6, 14, 22, 30,   
            7, 15, 23, 31    
        ];

        bitMap.forEach((bitIndex, i) => {
            reversedBits[bitIndex] = encodedBinary[i];
        });
      
        return reversedBits.join('');
       
    }

    encodeText() {
        const blocks = this.inputText.match(/.{1,4}/g); // Her 4 karakterlik bir blok oluşturur
        const encodedValues = [];
    
        blocks.forEach(block => {
            const binaryString = this.textToBinary(block).padEnd(32, '0');
            this.binaryString = binaryString;
    
            // Correctly calculate Decoded/Raw by reversing the order of bytes
            const decodedRaw = binaryString.match(/.{1,8}/g).reverse().join('');
            this.decodedRaw = decodedRaw;
    
            const encodedBinary = this.applyBitManipulation(decodedRaw);
            this.encodedBinary = encodedBinary;
    
            encodedValues.push(parseInt(encodedBinary, 2));
        });
    
        this.encodedValue = encodedValues; // Tüm encoded değerleri bir dizi olarak kaydet
    }
    

    decodeText() {
        const encodedValues = this.encodedValue; // assume this.encodedValue is an array of integers
        let decodedText = '';
    
        encodedValues.forEach(value => {
            // Convert each encoded integer back to a 32-bit binary string
            const encodedBinary = value.toString(2).padStart(32, '0');
    
            // Reverse the bit manipulation to get the original binary string
            const decodedBinary = this.reverseBitManipulation(encodedBinary);
    
            // Convert the binary string back to the original text
            const decodedRaw = decodedBinary.match(/.{1,8}/g).reverse().join('');
            decodedText += decodedRaw.match(/.{1,8}/g).map(byte => String.fromCharCode(parseInt(byte, 2))).join('');
        });
    
        this.decodedText = decodedText;
        console.log('Decoded Text:', decodedText);
    }
    
}