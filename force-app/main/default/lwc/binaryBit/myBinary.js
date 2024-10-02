import { LightningElement } from 'lwc';

export default class myBinary extends LightningElement {
    
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
       
        // Binary string'i 8-bit gruplarına ayırın
        const binaryArray = [];
        for (let i = 0; i < binaryString.length; i += 8) {
            binaryArray.push(binaryString.slice(i, i + 8));
        }
    
        // Diziyi istediğiniz sıraya göre yeniden düzenleyin
        const rearrangedBinary = [
            binaryArray[3], // 4. eleman
            binaryArray[2], // 3. eleman
            binaryArray[1], // 2. eleman
            binaryArray[0]  // 1. eleman
        ].join(" ");
    
        return rearrangedBinary.replace(/\s+/g, ''); // Boşlukları kaldırarak döndür
    }

    generateDynamicBinary() {
        // Dinamik Binary'yi sabit bir değer olarak döndürüyoruz
        // Bu değeri ihtiyaçlarınıza göre dinamik olarak oluşturabilirsiniz
        return "01001011 01000111 01011111 01110010";
    }

    performXOROperation(decodedRaw, dynamicBinary) {
        // XOR işlemi gerçekleştirin
        const decodedArray = decodedRaw.match(/.{1,8}/g); // 8 bitlik gruplara bölme
        const dynamicArray = dynamicBinary.split(" ");

        let xorResultArray = decodedArray.map((decodedByte, index) => {
            let xorResult = parseInt(decodedByte, 2) ^ parseInt(dynamicArray[index], 2);
            return xorResult.toString(2).padStart(8, '0');
        });

        return xorResultArray.join(' ');
    }

    generateDynamicDecodedToBinary(){
        return "01101011 01000111 01011111 01110010";
    }

    performToXORoper(encodedRaw, SecdynamicBinary){
        const encodedArray = encodedRaw.match(/.{1,8}/g);
        const dynamicArray = SecdynamicBinary.split(" ");

        let secXORresultArray = encodedArray.map((endcodedByte, index) => {
            letSecXorResult = parseInt(endcodedByte, 2) ^ parseInt(dynamicArray[index],2);
            return letSecXorResult.toString(2).padStart(8, '0');
        });

        return secXORresultArray.join(' ');
    }


    reverseBitManipulation(decodedBinary) {
        // Encoded Binary'yi 8-bitlik gruplara böl
        const decodedBinaryArray = [];
        for(let i=0; i< decodedBinary.length; i += 8){
            decodedBinaryArray.push(decodedBinary.slice(i, i+8));
        }
    
        // Eğer binaryArray undefined veya boşsa, burada bir sorun var demektir
        if (!decodedBinaryArray || decodedBinaryArray.length !== 4) {
            console.error('Error: Binary array is not correctly formed:', binaryArray);
            return '';  // Hatalı durumda boş string döndür
        }
    
        // Binary gruplarını ters sırayla birleştir
        const reversedBits = [
            decodedBinaryArray[3], // 4. eleman
            decodedBinaryArray[2], // 3. eleman
            decodedBinaryArray[1], // 2. eleman
            decodedBinaryArray[0]  // 1. eleman
        ].join(" ");
    
    
        return reversedBits.replace(/\s+/g, ''); // Boşlukları kaldırarak döndür
    }
    
  
    
    encodeText(){
        const binaryString = this.textToBinary(this.inputText).padEnd(32, '0');
        this.binaryString = binaryString;
        
        // Decoded/Raw değerini oluşturun
        const decodedRaw = binaryString.match(/.{1,8}/g).reverse().join('');
        this.decodedRaw = decodedRaw;

        // Dinamik Binary'yi oluşturun
        const dynamicBinary = this.generateDynamicBinary();

        // XOR işlemini gerçekleştirin
        const encodedBinary = this.performXOROperation(this.decodedRaw, dynamicBinary);
        this.encodedBinary = encodedBinary.replace(/\s+/g, '');

        // Encoded Binary'yi Decimal (10 tabanlı) sayıya çevirin
        this.encodedValue = parseInt(encodedBinary.replace(/\s+/g, ''), 2);  // Boşlukları kaldırıp decimal'e çevirme
        
    }

    decodeText() {
    const SecdynamicBinary = this.generateDynamicDecodedToBinary();

    const decodedBinary = this.performToXORoper(encodedRaw, SecdynamicBinary);
    this.decodedRaw = decodedBinary.replace(/\s+/g, '');

    const binaryString = decodedBinary.match(/.{1,8}/g).reverse().join('');
    this.binaryString = binaryString;

    const decodedText = this.binaryToText(this.binaryString);
    return decodedText;

    }
}
