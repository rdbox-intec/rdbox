import { Component } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { Router } from '@angular/router';

@Component({
  selector: 'app-verification-result-dialog',
  templateUrl: './verification-result-dialog.component.html',
  styleUrls: ['./verification-result-dialog.component.scss']
})
export class VerificationResultDialogComponent {

  constructor(public dialogRef: MatDialogRef<VerificationResultDialogComponent>,
    private router: Router) {
  }

  onNoClick(): void {
    this.dialogRef.close();
    this.router.navigate(['/bootstrap'])
  }

}
