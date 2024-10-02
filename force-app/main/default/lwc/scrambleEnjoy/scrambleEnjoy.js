import { LightningElement, track } from 'lwc';

export default class ScrambleEnjoy extends LightningElement {
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
        return text.split('').map(char => char.charCodeAt(0).toString(2).padStart(8, '0')).join('').padEnd(128, '0');
    }

    applyBitManipulation(binaryString) {
        if (binaryString.length !== 128) {  // 128 bits for 16 characters (4 segments of 8 characters)
            throw new Error("Binary string must be exactly 128 bits long.");
        }

        const manipulatedBits = new Array(128);
        const bitMap = [
            0, 1, 2, 3, 4, 5, 6, 7,    // Manipulate the bits as per requirement
            64, 65, 66, 67, 68, 69, 70, 71, 
            8, 9, 10, 11, 12, 13, 14, 15,
            72, 73, 74, 75, 76, 77, 78, 79,
            16, 17, 18, 19, 20, 21, 22, 23,
            80, 81, 82, 83, 84, 85, 86, 87,
            24, 25, 26, 27, 28, 29, 30, 31,
            88, 89, 90, 91, 92, 93, 94, 95,
            32, 33, 34, 35, 36, 37, 38, 39,
            96, 97, 98, 99, 100, 101, 102, 103,
            40, 41, 42, 43, 44, 45, 46, 47,
            104, 105, 106, 107, 108, 109, 110, 111,
            48, 49, 50, 51, 52, 53, 54, 55,
            112, 113, 114, 115, 116, 117, 118, 119,
            56, 57, 58, 59, 60, 61, 62, 63,
            120, 121, 122, 123, 124, 125, 126, 127
        ];

        bitMap.forEach((bitIndex, i) => {
            manipulatedBits[i] = binaryString[bitIndex];
        });

        return manipulatedBits.join('');
    }

    reverseBitManipulation(encodedBinary) {
        if (encodedBinary.length !== 128) {  // 128 bits for 16 characters (4 segments of 8 characters)
            throw new Error("Binary string must be exactly 128 bits long.");
        }

        const reversedBits = new Array(128);
        const bitMap = [
            0, 1, 2, 3, 4, 5, 6, 7,    
            64, 65, 66, 67, 68, 69, 70, 71, 
            8, 9, 10, 11, 12, 13, 14, 15,
            72, 73, 74, 75, 76, 77, 78, 79,
            16, 17, 18, 19, 20, 21, 22, 23,
            80, 81, 82, 83, 84, 85, 86, 87,
            24, 25, 26, 27, 28, 29, 30, 31,
            88, 89, 90, 91, 92, 93, 94, 95,
            32, 33, 34, 35, 36, 37, 38, 39,
            96, 97, 98, 99, 100, 101, 102, 103,
            40, 41, 42, 43, 44, 45, 46, 47,
            104, 105, 106, 107, 108, 109, 110, 111,
            48, 49, 50, 51, 52, 53, 54, 55,
            112, 113, 114, 115, 116, 117, 118, 119,
            56, 57, 58, 59, 60, 61, 62, 63,
            120, 121, 122, 123, 124, 125, 126, 127
        ];

        bitMap.forEach((bitIndex, i) => {
            reversedBits[bitIndex] = encodedBinary[i];
        });

        return reversedBits.join('');
    }

    encodeText() {
        const binaryString = this.textToBinary(this.inputText);
        this.binaryString = binaryString;

        // Reverse the order of 8-bit segments (rearrange characters)
        const decodedRaw = binaryString.match(/.{1,8}/g).reverse().join('');
        this.decodedRaw = decodedRaw;

        // Apply bit manipulation to get the encoded binary string
        const encodedBinary = this.applyBitManipulation(decodedRaw);
        this.encodedBinary = encodedBinary;

        // Convert encoded binary to integer value
        const encodedValueArray = [
            parseInt(encodedBinary.slice(0, 64), 2),
            parseInt(encodedBinary.slice(64, 128), 2)
        ];
        this.encodedValue = JSON.stringify(encodedValueArray);
    }

    decodeText() {
        const decodedBinary = this.reverseBitManipulation(this.encodedBinary);
        const decodedRaw = decodedBinary.match(/.{1,8}/g).reverse().join('');
        this.decodedText = decodedRaw.match(/.{1,8}/g).map(byte => String.fromCharCode(parseInt(byte, 2))).join('');
    }
}
