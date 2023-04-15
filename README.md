# All For All - A civic tech distributed storage

## Problem
ข้อมูล Video เป็นข้อมูลที่ดี ปลอมแปลงยาก(ประเด็น 1) เป็นหลักฐานชั้นหนึ่ง แต่มีขนาดใหญ่มีค่าใช้จ่ายสูง(ประเด็น 2) และเรากลัวจะรบกวนอาสามากเกินไป(ประเด็น 3)

## ข้อเท็จจริง
ถ้าเราจะเก็บ Video การนับคะแนนทุก`หน่วยเลือกตั้ง ~90k หน่วย (1080p, 30fps, เข้ารหัส H.265, 1 ชม) [จะใช้พื้นที่](https://www.seagate.com/as/en/video-storage-calculator/)


```math
90k * 756 MB = ~68 TB 
```

เก็บบน R2, Cloudflare [เสียเงิน](https://r2-calculator.cloudflare.com/) 

```math
$12,519.00 /yr 
```

เราไม่มีตัง 😭 ถ้าอยากเก็บจริงๆจะทำไง? 

## Proposed Solution A
Pool Cloud Storage เช่น Google Drive, Dropbox, Onedrive ของแต่ละคนมารวมกัน แล้วแยกเก็บแบบมี redundancy ชั่วคราวประมาณ 1 ปีแล้วเลิก

## Proposed Solution B
Pool Cloud Storage บนเครื่องคอมฯ ด้วย IPFS or similar

## Maintain ไง
ดู redundance count ถ้าต่ำกว่า threshold ให้เพิ่มสำเนา